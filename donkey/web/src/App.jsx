import React, { Component } from "react";
import "./App.css";
import Donkeys from "./scenes/donkeys";

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          Donkeys
          <Donkeys />
        </header>
      </div>
    );
  }
}

export default App;
