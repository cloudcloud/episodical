package event

import (
	"context"
	"fmt"

	"github.com/gorilla/websocket"
	"go.uber.org/zap"
)

// EventKey allows for the addressing of context keys to pull data
// through for event processing.
type EventKey string

// EventHandler is a function type that defines how event handling
// functions are structured.
type EventHandler func(Eventer) (*Event, error)

const (
	// KeyData is the reference key used to store the database handler.
	KeyData EventKey = "db"

	// KeyLog is the reference key used to store the logger.
	KeyLog EventKey = "log"
)

var (
	conn   *websocket.Conn
	events map[string]Eventer
)

func init() {
	events = make(map[string]Eventer, 0)
}

func Capture(e Eventer) {
	var (
		ev  *Event
		err error
	)
	events[e.Identifier()] = e

	switch e.Type() {
	case "refresh/episodic": // refreshing a particular entity
		ev, err = handleRefreshEpisodic(e)

	default:
		// unknown event, error handle
		//

		return
	}

	if err != nil {
		ev.Log().
			With("error", err).
			With("type", ev.Type()).
			Error("Unable to process event")
	}

	processed(ev)
}

// Processed will accept an Eventer with some payload to
// complete the event and send a response.
func processed(e Eventer) {
	//
}

// Eventer allows for different types of Event style types to be
// used for event processing purposes.
type Eventer interface {
	Acknowledge() []byte
	Identifier() string
	Type() string
}

// Event is a structure that will hold details around a specific
// event to be processed and identifying details for that event.
type Event struct {
	ID      string `json:"id"`
	Payload struct {
		ID   string `json:"id"`
		Type string `json:"type"`

		Content map[string]any `json:"content"`
	} `json:"payload"`

	conn string
	ctx  context.Context
}

// New will provision a fresh Event to be used for capturing
// and processing some sort of event.
func New(ctx context.Context, id string) Eventer {
	return &Event{
		conn: id,
		ctx:  ctx,
	}
}

// Acknowledge will generate a message to send back to the client
// that will serve as an acknowledgement for the original.
func (e *Event) Acknowledge() []byte {
	return []byte(fmt.Sprintf(`{"ack":%q}`, e.ID))
}

// Identifier will return the specific Event ID value.
func (e *Event) Identifier() string {
	if e == nil {
		return ""
	}
	return e.ID
}

// Log will return the logger for the Eventer.
func (e *Event) Log() *zap.SugaredLogger {
	if e == nil {
		return nil
	}
	return e.ctx.Value(KeyLog).(*zap.SugaredLogger)
}

// Type will return the specific Event Type value.
func (e *Event) Type() string {
	if e == nil {
		return ""
	}
	return e.Payload.Type
}
