package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("./front-end"))
	http.Handle("/", fs)

	log.Println("Listening...")
	http.ListenAndServe(":8080", nil)
}
