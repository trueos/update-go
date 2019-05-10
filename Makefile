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

# We will add test later
all: format lint build

build:
	$(GOBUILD) -o $(BINARY_NAME) -v
format:
	$(GOCMD) fmt ./...
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
