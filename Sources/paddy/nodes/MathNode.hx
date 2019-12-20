package paddy.nodes;

import kha.Color;
import zui.Nodes.TNode;

class MathNode {

    public static var maths: TNode = {
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
                color: Color.fromBytes(90, 220, 90),
                default_value: 0.0
            },
            {
                id: 1,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.fromBytes(90, 220, 90),
                default_value: 0.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.fromBytes(90, 220, 90),
                default_value: 0.0
            }
        ],
        buttons: [
            {
                name: "Operations",
                type: "ENUM",
                data: ["Addition", "Substraction", "Multiplication", "Division"]
            }
        ],
        color: Color.fromBytes(180, 70, 70)
    }

    public static var radtodeg: TNode = {
        id: 0,
        name: "Radian to Degre",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Radian",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Degree",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var degtorad: TNode = {
        id: 0,
        name: "Degree to Radian",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Degree",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Radian",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var randf: TNode = {
        id: 0,
        name: "Random (Float)",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [],
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
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }

    public static var randi: TNode = {
        id: 0,
        name: "Random (Int)",
        type: "VALUE",
        x: 200,
        y: 200,
        inputs: [],
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
        buttons: [],
        color: Color.fromBytes(50, 50, 200)
    }
}
