package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type response struct {
	Content []donkey `json:"content"`
	Links   []link   `json:"links"`
}

type donkey struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
	Links []link `json:"links"`
}

type link struct {
	Rel  string `json:"rel"`
	Href string `json:"href"`
}

func handler(
	ctx context.Context,
	request events.APIGatewayProxyRequest,
) (
	events.APIGatewayProxyResponse,
	error,
) {
	apiURL := os.Getenv("API_URL")
	var resp response
	resp.Links = []link{
		{
			Rel:  "self",
			Href: fmt.Sprintf("%s/donkeys", apiURL),
		},
		{
			Rel:  "up",
			Href: apiURL,
		},
	}
	resp.Content = []donkey{
		{
			ID:   "1",
			Name: "Bosse",
			Links: []link{{
				Rel:  "self",
				Href: fmt.Sprintf("%s/donkeys/%s", apiURL, "1"),
			}},
		},
		{
			ID:   "2",
			Name: "Uffe",
			Links: []link{{
				Rel:  "self",
				Href: fmt.Sprintf("%s/donkeys/%s", apiURL, "2"),
			}},
		},
	}

	body, _ := json.Marshal(resp)
	return events.APIGatewayProxyResponse{
		Body:       string(body),
		Headers:    map[string]string{"Access-Control-Allow-Origin": "*"},
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
