package paddy.nodes;

import kha.Color;
import zui.Nodes.TNode;

class VariableNode {

    public static var string: TNode = {
        id: 0,
        name: "String",
        type: "StringNode",
        x: 200,
        y: 200,
        inputs: [],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "String",
                type: "STRING",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        buttons: [
            {
                name: "value",
                type: "STRING",
                default_value: "",
                output: 0
            }
        ],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var float: TNode = {
        id: 0,
        name: "Float",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: [
            {
                name: "Float",
                type: "VALUE",
                default_value: 0.0,
                min: 0.0,
                max: 100.0,
                output: 0
            }
        ],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var boolean: TNode = {
        id: 0,
        name: "Boolean",
        type: "BOOL",
        x: 200,
        y: 200,
        inputs: [],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "",
                type: "BOOL",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: [
            {
                name: "Boolean",
                type: "BOOL",
                default_value: false,
                output: 0
            }
        ],
        color: Color.fromBytes(50, 50, 200)
    }
    
}