package paddy.nodes;

import kha.Color;
import zui.Nodes.TNode;

class MathNode {

    public static var maths: TNode = {
        id: 0,
        name: "Maths",
        type: "MathNode",
        x: 200,
        y: 200,
        color: -4962746,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.fromBytes(90, 220, 90),
                default_value: 0.0,
                max: 100.0
            },
            {
                id: 1,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.fromBytes(90, 220, 90),
                default_value: 0.0,
                max: 100.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "value",
                type: "Value",
                color: Color.fromBytes(90, 220, 90),
                default_value: 0.0
            }
        ],
        buttons: [
            {
                name: "operations",
                type: "ENUM",
                data: ["Add", "Subtract", "Multiply", "Divide"],
                output: 0,
                default_value: 0
            }
        ]
    }

    public static var radtodeg: TNode = {
        id: 0,
        name: "Radian to Degre",
        type: "RadToDegNode",
        x: 200,
        y: 200,
        color: -4962746,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Rad",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0,
                max: 6.28
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Deg",
                type: "Value",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: []
    }

    public static var degtorad: TNode = {
        id: 0,
        name: "Degree to Radian",
        type: "DegToRadNode",
        x: 200,
        y: 200,
        color: -4962746,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Deg",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0,
                max: 360.0
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Rad",
                type: "Value",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: []
    }

    public static var randf: TNode = {
        id: 0,
        name: "Random (Float)",
        type: "RandFNode",
        x: 200,
        y: 200,
        color: -4962746,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Value",
                type: "VALUE",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0,
                max: 100.0
            },
            {
                id: 1,
                node_id: 0,
                name: "Value",
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
                type: "Value",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0.0
            }
        ],
        buttons: []
    }

    public static var randi: TNode = {
        id: 0,
        name: "Random (Int)",
        type: "RandINode",
        x: 200,
        y: 200,
        color: -4962746,
        inputs: [
            {
                id: 0,
                node_id: 0,
                name: "Value",
                type: "INT",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0,
                max: 100
            },
            {
                id: 1,
                node_id: 0,
                name: "Value",
                type: "INT",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0,
                max: 100
            }
        ],
        outputs: [
            {
                id: 0,
                node_id: 0,
                name: "Int",
                type: "Value",
                color: Color.fromBytes(180, 180, 180),
                default_value: 0
            }
        ],
        buttons: []
    }
}
