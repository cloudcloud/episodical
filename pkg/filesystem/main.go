package filesystem

import (
	"context"
	"io/fs"
	"os"
	"time"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/types"
	"go.uber.org/zap"
)

var (
	validEpisodical = map[string]struct{}{
		"mkv": struct{}{},
		"avi": struct{}{},
		"mp4": struct{}{},
		"mov": struct{}{},
	}
	validArtistic = map[string]struct{}{}
	validDocument = map[string]struct{}{}
)

type Process struct {
	db  *data.Base
	fs  *types.Filesystem
	log *zap.SugaredLogger
}

func Load(fs *types.Filesystem, db *data.Base, log *zap.SugaredLogger) *Process {
	return &Process{
		fs:  fs,
		db:  db,
		log: log,
	}
}

// Gather will process the internal filesystem and look for files to utilise.
func (p *Process) Gather(b *types.Episodic, t string) (int, error) {
	ctx := context.Background()
	system := os.DirFS(p.fs.BasePath + string(os.PathSeparator) + b.Path)

	switch t {
	case "episodical":
		p.gatherFromFilesystem(b, ctx, system)
		// fmt.Printf("%#v\n", tvmaze.Search(b.Title))

	case "artistic":
		// mp3, aac, flac, ogg

	case "document":
		// pdf, txt

	}

	return 0, nil
}

func (p *Process) gatherFromFilesystem(b *types.Episodic, ctx context.Context, system fs.FS) error {
	// mkv, mp4, avi, mov
	files := []*types.File{}
	fs.WalkDir(system, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			p.log.With("error", err).Info("Walk process stopping")
			return err
		}
		if d.IsDir() {
			return nil
		}

		f, err := types.TokeniseEpisodical(path)
		if err != nil {
			return err
		}

		format, err := f.GetToken("Format")
		if err != nil {
			return err
		}
		if _, ok := validEpisodical[format.(string)]; !ok {
			return nil
		}

		files = append(files, f)
		return nil
	})

	for _, f := range files {
		// add each episode to the episodical
		ep, err := b.ProvisionEpisode(f)
		if err != nil {
			p.log.With("error", err, "file", f).Info("Unable to parse episode details")
			continue
		}

		orig, err := p.db.GetEpisodeSearch(ctx, ep)
		if err != nil {
			p.log.With("error", err, "episode", ep).Info("Error when searching for found episode")
		}

		if orig != nil {
			ep.ID = orig.ID
			ep.DateAdded = orig.DateAdded
			ep.DateUpdated = time.Now()

			err = p.db.UpdateEpisode(ctx, ep)
		} else {
			err = p.db.StoreEpisode(ctx, ep)
		}

		if err != nil {
			// log and continue
		}
	}

	return nil
}
