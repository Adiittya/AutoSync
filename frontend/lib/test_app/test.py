from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/remote_widget', methods=['GET'])
def get_remote_widget():
    center = {
        "center_name": "Volks Auto Service Mumbai",
        "address": {
            "street": "Plot 12, Andheri Industrial Estate",
            "city": "Mumbai",
            "state": "Maharashtra",
            "pincode": "400053"
        },
        "contact": "+91-9876543210",
        "location": {"coordinates": [72.868, 19.119]},
        "parts_available": [
            {"part_name": "Brake Pad", "quantity": 20, "price": 1800},
            {"part_name": "Engine Oil", "quantity": 50, "price": 700},
        ]
    }

    # Precompute strings & lat/lng
    address_text = f"{center['address']['street']}, {center['address']['city']}, {center['address']['state']} - {center['address']['pincode']}"
    lat, lng = center["location"]["coordinates"][1], center["location"]["coordinates"][0]

    # Precompute parts as Text widgets
    parts_children = []
    for p in center["parts_available"]:
        parts_children.append({
            "widget": "Text",
            "text": [f"{p['part_name']} - Qty: {p['quantity']}, ₹{p['price']}"],
            "style": {
                "fontSize": 15,
                "color": 0xFF000000
            }
        })

    data = {
        "MyServiceCenterCard": {
            "center_name": center["center_name"],
            "address_text": address_text,
            "contact": center["contact"],
            "lat": lat,
            "lng": lng,
            "parts_children": parts_children
        }
    }

    rfw_text = """\
import core.widgets;
import material.widgets;

widget MyCard = Card(
  color: 0xFFE0E0E0,
  margin: [16.0],
  shape: RoundedRectangleBorder(borderRadius: 16),
  child: Column(
    crossAxisAlignment: "start",
    children: [
      SizedBox(height: 10),
      Center(
        child: Text(
          text: [data.MyServiceCenterCard.center_name],
          textDirection: "ltr",
          style: TextStyle(fontSize: 18, fontWeight: "bold", color: 0xFF000000)
        )
      ),
      SizedBox(height: 5),
      Center(
        child: Text(
          text: [data.MyServiceCenterCard.address_text],
          textDirection: "ltr",
          style: TextStyle(fontSize: 15, fontWeight: "w500", color: 0xFF555555),
          textAlign: "center"
        )
      ),
      SizedBox(height: 10),
      Text(
        text: ["Availability:"],
        textDirection: "ltr",
        style: TextStyle(fontSize: 15, fontWeight: "bold", color: 0xFF000000)
      ),
      Column(
        crossAxisAlignment: "start",
        children: data.MyServiceCenterCard.parts_children
      ),
      SizedBox(height: 15),
      ElevatedButton(
        child: Text(text: ["Drive Now"], textDirection: "ltr"),
        onPressed: event "drive_now" {
          lat: data.MyServiceCenterCard.lat,
          lng: data.MyServiceCenterCard.lng
        }
      ),
      SizedBox(height: 5),
      ElevatedButton(
        child: Text(text: ["Call Center"], textDirection: "ltr"),
        onPressed: event "call_center" {
          phone: data.MyServiceCenterCard.contact
        }
      ),
      SizedBox(height: 10)
    ]
  )
);
"""

    return jsonify({"rfw": rfw_text, "data": data})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
