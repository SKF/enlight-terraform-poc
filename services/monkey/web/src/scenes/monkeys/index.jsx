import React from "react"

// eslint-disable-next-line
let API_URL = config.api

export default class Monkeys extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      error: null,
      isLoaded: false,
      items: [],
    };
  }

  componentDidMount() {
    const options = {
      headers: {
        "Authorization": "...",
        "Content-Type": "application/json; charset=utf-8"
      }
    };

    fetch(API_URL + "/monkeys", options)
      .then(res => res.json())
      .then(
        (result) => {
          this.setState({
            isLoaded: true,
            items: result.content
          });
        },
        (error) => {
          this.setState({
            isLoaded: true,
            error
          });
        }
      )
  }

  render() {
    const { error, isLoaded, items } = this.state;
    if (error) {
      return <div>Error: {error.message}</div>;
    } else if (!isLoaded) {
      return <div>Loading...</div>;
    } else {
      return (
        <ul>
          {items.map(item => (
            <li key={item.id}>
              {item.name}
            </li>
          ))}
        </ul>
      );
    }
  }
}
