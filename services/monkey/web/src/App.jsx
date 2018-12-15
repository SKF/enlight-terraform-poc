import React, { Component } from "react";
import "./App.css";
import Monkeys from "./scenes/monkeys";

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          Monkeys
          <Monkeys />
        </header>
      </div>
    );
  }
}

export default App;
