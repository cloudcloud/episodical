package types

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestConvertFilesystem(t *testing.T) {
	assert := assert.New(t)

	f := &AddFilesystem{
		Title: "title",
	}

	out, err := f.Convert()

	assert.Nil(err)
	assert.NotNil(out.ID)
	assert.Equal(f.Title, out.Title)
}
