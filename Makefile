PACKAGE := github.com/gpolek/amqp
FUZZ_DIR := ./fuzz

all: test

.PHONY: fuzzconn
fuzzconn:
	go-fuzz-build -o $(FUZZ_DIR)/conn.zip -func FuzzConn $(PACKAGE)
	go-fuzz -bin $(FUZZ_DIR)/conn.zip -workdir $(FUZZ_DIR)/conn

.PHONE: fuzzmarshal
fuzzmarshal:
	go-fuzz-build -o $(FUZZ_DIR)/marshal.zip -func FuzzUnmarshal $(PACKAGE)
	go-fuzz -bin $(FUZZ_DIR)/marshal.zip -workdir $(FUZZ_DIR)/marshal

.PHONY: fuzzclean
fuzzclean:
	rm -f $(FUZZ_DIR)/**/{crashers,suppressions}/*
	rm -f $(FUZZ_DIR)/*.zip

.PHONY: test
test:
	TEST_CORPUS=1 go test -tags gofuzz -race -run=Corpus
	go test -tags gofuzz -v -race ./...

.PHONY: coverage
coverage:
	TEST_CORPUS=1 go test -tags gofuzz -cover -coverprofile=cover.out -v
