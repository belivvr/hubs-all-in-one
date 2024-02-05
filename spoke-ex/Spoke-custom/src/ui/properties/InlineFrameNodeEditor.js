import React, { Component } from "react";
import PropTypes from "prop-types";
import NodeEditor from "./NodeEditor";
import InputGroup from "../inputs/InputGroup";
import StringInput from "../inputs/StringInput";
import SelectInput from "../inputs/SelectInput";
import { Inbox } from "styled-icons/fa-solid/Inbox"


export const options = {
  main: "Main",
  sideView: "Side view"
};

const frameOptions = Object.values(options).map(v => ({ label: v, value: v }));


export default class InlineFrameNodeEditor extends Component {
  static propTypes = {
    editor: PropTypes.object,
    node: PropTypes.object
  };

  static iconComponent = Inbox;

  static description = `Link to a open another website by iframe`;

  onChangeImageURL = imageURL => {
    this.props.editor.setPropertySelected("imageURL", imageURL);
  };

  onChangeSrc = src => {
    this.props.editor.setPropertySelected("src", src);
  };

  onChangeFrameOption = option => {
    this.props.editor.setPropertySelected("frameOption", option);
  };

  render() {
    const node = this.props.node;

    return (
      <NodeEditor description={InlineFrameNodeEditor.description} {...this.props}>
        <InputGroup name="Image URL">
          <StringInput value={node.imageURL} onChange={this.onChangeImageURL} />
        </InputGroup>
        <InputGroup name="URL">
          <StringInput value={node.src} onChange={this.onChangeSrc} />
        </InputGroup>
        <InputGroup name="Frame Option">
          <SelectInput options={frameOptions} value={node.frameOption} onChange={this.onChangeFrameOption} />
        </InputGroup>
      </NodeEditor>
    );
  }
}
