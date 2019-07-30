package main

import (
	"net/http"
	"testing"
)

func TestDoubleHandler(t *testing.T) {
	http.NewRequest("GET", "localhost:8080/double?v=2", nil)
	if err != nil {
		t.Fatalf("could not created request: %v", err)

	}

}
