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
        color: -13487416,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "String",
                type: "STRING",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
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
        buttons: []
    }

    public static var float: TNode = {
        id: 0,
        name: "Float",
        type: "FloatNode",
        x: 200,
        y: 200,
        color: -13487416,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Float",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0,
                max: 100.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Float",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: []
    }

    public static var int: TNode = {
        id: 0,
        name: "Int",
        type: "IntegerNode",
        x: 200,
        y: 200,
        color: -13487416,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Int",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0,
                max: 100,
                precision: 1
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Int",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0
            }
        ],
        buttons: []
    }

    public static var boolean: TNode = {
        id: 0,
        name: "Boolean",
        type: "BoolNode",
        x: 200,
        y: 200,
        color: -13487416,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Bool",
                type: "BOOLEAN",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Bool",
                type: "BOOLEAN",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        buttons: []
    }

}
