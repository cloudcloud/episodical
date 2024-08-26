package types

type Stmt interface {
	GetBool(colName string) bool
	GetBytes(colName string, buf []byte) int
	GetFloat(colName string) float64
	GetInt64(colName string) int64
	GetText(colName string) string
}
