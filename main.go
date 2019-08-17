package main

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
)

func main() {
	err := http.ListenAndServe(":8080", handler())
	if err != nil {
		log.Fatal(err)
	}
}

func handler() http.Handler {
	r := http.NewServeMux()
	r.HandleFunc("/", rootHandler)
	r.HandleFunc("/double", doubleHandler)
	return r
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	page := `<!DOCTYPE html>
	<html lang="en">
	<meta charset="utf-8">
	<head>
	 <title>Welcome to EPAM</title>
	 <style>
	   body {
		   background: blue }
	   section {
		   background: black;
		   color: white;
		   border-radius: 1em;
		   padding: 1em;
		   position: absolute;
		   top: 50%;
		   left: 50%;
		   margin-right: -50%;
		   transform: translate(-50%, -50%) }
	 </style>
	</head>
	<body>
	 <section>
	  <h1>DevOps</h1>
	  <p>Автоматизация процесса разработки</p>
	 </section>
	</body>
	</html>`
	fmt.Fprintf(w, page)
}

func doubleHandler(w http.ResponseWriter, r *http.Request) {
	text := r.FormValue("v")
	if text == "" {
		http.Error(w, "missing value", http.StatusBadRequest)
		return
	}
	v, err := strconv.Atoi(text)
	if err != nil {
		http.Error(w, "not a number: "+text, http.StatusBadRequest)
		return
	}

	fmt.Fprintln(w, v*2)
}
