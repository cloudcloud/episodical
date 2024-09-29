package sock

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/cloudcloud/episodical/pkg/data"
	"github.com/cloudcloud/episodical/pkg/event"
	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
	"github.com/segmentio/ksuid"
	"go.uber.org/zap"
)

type Socket struct {
	Requests map[string]*Conn
}

type Conn struct {
	Conn *websocket.Conn
	ID   string
}

// New will provision a Socket that is capable of accepting
// new connections and managing the communication from and
// then back to clients.
func New() *Socket {
	return &Socket{
		Requests: make(map[string]*Conn, 0),
	}
}

// Handle is called to accept a new socket connection.
func (s *Socket) Handle(c *gin.Context) {
	db := c.MustGet("db").(*data.Base)
	log := c.MustGet("log").(*zap.SugaredLogger)

	upgrader := websocket.Upgrader{}
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	id, err := ksuid.NewRandom()
	if err != nil {
		log.With("error", err).Error("Unable to generate ksuid for sock")
		return
	}

	s.Requests[id.String()] = &Conn{Conn: conn, ID: id.String()}
	defer conn.Close()

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			log.With("error", err).Info("Unable to read message")
			break
		}

		ctx := context.WithValue(context.WithValue(c.Copy(), event.KeyData, db), event.KeyLog, log)
		ev := event.New(ctx, id.String())
		err = json.Unmarshal(msg, ev)
		if err != nil {
			log.With("error", err).Info("Unable to generate Event")
			continue
		}

		event.Capture(ev)

		err = conn.WriteMessage(websocket.TextMessage, ev.Acknowledge())
		if err != nil {
			log.With("error", err).Info("Unable to write acknowledgement")
			break
		}
	}
}

func (s *Socket) Respond(d []byte) error {
	return nil
}
