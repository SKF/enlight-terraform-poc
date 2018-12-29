package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

type request struct {
	Type               string `json:"type"`
	AuthorizationToken string `json:"authorizationToken"`
	MethodArn          string `json:"methodArn"`
}

type response struct {
	PrincipalID    principalID       `json:"principalId"`
	PolicyDocument policyDocument    `json:"policyDocument"`
	Context        map[string]string `json:"context"`
}

type principalID string
type effect string

type policyDocument struct {
	Version   string
	Statement []statement
}

type statement struct {
	Action   string
	Effect   effect
	Resource string
}

func handler(ctx context.Context, req request) (resp response, _ error) {
	fmt.Println(`{"message":"authorizer.handler", "level":"warn"}`)

	resp.PrincipalID = "user"
	resp.PolicyDocument = policyDocument{
		Version: "2012-10-17",
		Statement: []statement{
			statement{
				Action:   "execute-api:Invoke",
				Effect:   "Allow",
				Resource: req.MethodArn,
			},
		},
	}
	return resp, nil
}

func main() {
	lambda.Start(handler)
}
