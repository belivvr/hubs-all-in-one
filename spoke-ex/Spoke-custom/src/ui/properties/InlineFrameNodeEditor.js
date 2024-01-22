import React, { Component } from "react";
import PropTypes from "prop-types";
import NodeEditor from "./NodeEditor";
import InputGroup from "../inputs/InputGroup";
import StringInput from "../inputs/StringInput";
import { Inbox } from "styled-icons/fa-solid/Inbox"


export default class InlineFrameNodeEditor extends Component {
  static propTypes = {
    editor: PropTypes.object,
    node: PropTypes.object
  };

  static iconComponent = Inbox;

  static description = `Link to a open another website by iframe`;

  onChangeSrc = src => {
    this.props.editor.setPropertySelected("src", src);
  };

  render() {
    const node = this.props.node;

    return (
      <NodeEditor description={InlineFrameNodeEditor.description} {...this.props}>
        <InputGroup name="Url">
          <StringInput value={node.src} onChange={this.onChangeSrc} />
        </InputGroup>
      </NodeEditor>
    );
  }
}
