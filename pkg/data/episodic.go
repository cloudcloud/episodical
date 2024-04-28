package data

import (
	"context"

	"github.com/cloudcloud/episodical/pkg/types"
)

func (d *Data) GetEpisodics(ctx *context.Context) ([]*types.Episodic, error) {
	return []*types.Episodic{}, nil
}

func (d *Data) GetEpisodicByID(ctx *context.Context, u string) (*types.Episodic, error) {
	return nil, nil
}
