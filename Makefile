# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOCYCLO=gocyclo
GOLINT=golint
INEFF=ineffassign
GOGET=$(GOCMD) get
MISSPELL=misspell
BINARY_NAME=sysup
GITHUB=github.com/

# We will add test later
all: build install
dev : format install-deps lint build

build:
	$(GOBUILD) -o $(BINARY_NAME) -v
install:
	$(GOCMD) install
format:
	$(GOCMD) fmt ./...
install-deps:
	go get $(GITHUB)fzipp/gocyclo \
		golang.org/x/lint/golint \
		$(GITHUB)gordonklaus/ineffassign \
		$(GITHUB)client9/misspell
lint:
	$(GOCMD) vet ./...
	$(GOCYCLO) -over 15 pkg logger trains update utils ws defines client
	$(GOLINT) ./...
	$(INEFF) ./
	$(MISSPELL) -w ./
test:
	$(GOTEST) -v ./...
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
run:
	$(GOBUILD) -o $(BINARY_NAME) -v ./...
	./$(BINARY_NAME)
