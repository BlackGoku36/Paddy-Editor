package paddy.nodes;

import kha.Color;

class MathsNode {

    public static var maths:zui.Nodes.TNode = {
        id: 0,
        name: "Maths",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.Blue,
                default_value: 0.0
            },
            {
                id: 1,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.Blue,
                default_value: 0.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.Blue,
                default_value: 0.0
            }
        ],
        buttons: [
            {
                name: "Operations",
                type: "ENUM",
                data: ["Add", "Subs", "Mult", "Div"]
            }
        ],
        color: Color.Blue
    }
}