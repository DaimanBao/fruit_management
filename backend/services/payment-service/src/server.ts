import "dotenv/config";
import app from "./app";
import prisma from "./config/prisma";

const PORT = Number(process.env.PORT) || 3005;

async function startServer() {
    try {
        await prisma.$connect();

        console.log("PostgreSQL connected successfully!");

        app.listen(PORT, () => {
            console.log(`Auth Service running at http://localhost:${PORT}`);
        });
    } catch (error) {
        console.error("Failed to start Payment Service:", error);
        process.exit(1);
    }
}

startServer();