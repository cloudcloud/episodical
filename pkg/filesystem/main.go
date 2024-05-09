package filesystem

import (
	"io/fs"
	"log"
	"os"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/types"
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
	db *data.Base
	fs *types.Filesystem
}

func Load(fs *types.Filesystem, db *data.Base) *Process {
	return &Process{
		fs: fs,
		db: db,
	}
}

// Gather will process the internal filesystem and look for files to utilise.
func (p *Process) Gather(b, t string) (int, error) {
	system := os.DirFS(p.fs.BasePath + string(os.PathSeparator) + b)

	switch t {
	case "episodical":
		// mkv, mp4, avi, mov
		files := []*types.File{}
		fs.WalkDir(system, ".", func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				log.Println(err.Error())
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
			log.Println(f.GetToken("Episode"))
		}

	case "artistic":
		// mp3, aac, flac, ogg

	case "document":
		// pdf, txt

	}

	return 0, nil
}
