package paddy.nodes;

import kha.Color;
import zui.Nodes.TNode;

class StdNode {

    public static var parseInt: TNode = {
        id: 0,
        name: "Parse Int",
        type: "STRING",
        x: 200,
        y: 200,
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
                name: "Int",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var parseFloat: TNode = {
        id: 0,
        name: "Parse Float",
        type: "STRING",
        x: 200,
        y: 200,
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
                name: "Float",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var floatToInt: TNode = {
        id: 0,
        name: "Float to Int",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Float",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Int",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: ""
            }
        ],
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }
    
}