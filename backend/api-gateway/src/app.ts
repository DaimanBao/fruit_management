import express from 'express';
import cors from 'cors';

const app = express();

app.use(cors(
    {origin: "http://localhost:4200"}
));

app.use(express.json());

app.get('/health', (_req, res) => {
    res.status(200).json(
        {
            "status" : "ok",
            "service" : "api-gateway",
        }
    )
})

export default app