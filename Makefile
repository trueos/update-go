# Go parameters
GOPATHVARS!=	echo ${GOPATH} | sed 's|:| |g'
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

.for gpath in ${GOPATHVARS}
PATHVAR:=	${PATHVAR}${gpath}/bin:
.endfor

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
	env PATH=${PATHVAR} $(GOCYCLO) -over 15 pkg logger trains update utils ws defines client
	env PATH=${PATHVAR} $(GOLINT) ./...
	env PATH=${PATHVAR} $(INEFF) ./
	env PATH=${PATHVAR} $(MISSPELL) -w ./
test:
	$(GOTEST) -v ./...
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
run:
	$(GOBUILD) -o $(BINARY_NAME) -v ./...
	./$(BINARY_NAME)
