import unittest
from fastapi.testclient import TestClient
from server import app

class TestKrishiSahayakBackend(unittest.TestCase):
    def setUp(self):
        self.client = TestClient(app)

    test_root_health_check = None # placeholder line for formatting

    def test_root_endpoint(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["service"], "KrishiSahayak AI Backend Engine")

    def test_health_check_endpoint(self):
        response = self.client.get("/api/health")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["status"], "healthy")

    def test_schemes_list_endpoint(self):
        response = self.client.get("/api/schemes")
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["status"], "success")
        self.assertGreaterEqual(data["count"], 5)

    def test_ai_chatbot_rag_endpoint(self):
        payload = {
            "farmer_id": "farmer_101",
            "prompt": "Am I eligible for PM-KISAN scheme?",
            "state": "Maharashtra",
            "crop": "Cotton",
            "land_size_acres": 3.0,
            "language": "en"
        }
        response = self.client.post("/api/chat", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["status"], "success")
        self.assertIn("PM-KISAN", data["response_text"])

    def test_recommend_schemes_endpoint(self):
        payload = {
            "state": "Maharashtra",
            "district": "Nashik",
            "crop_type": "Cotton",
            "land_size_acres": 3.0,
            "farmer_category": "Small Farmer",
            "annual_income": 120000,
            "age": 38,
            "gender": "Male"
        }
        response = self.client.post("/api/recommend-schemes", json=payload)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data["status"], "success")
        self.assertGreaterEqual(data["total_qualified_schemes"], 1)

if __name__ == "__main__":
    unittest.main()
