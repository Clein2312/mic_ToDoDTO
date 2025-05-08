up:
	docker compose down
	docker compose up --build -d

stop:
	docker compose down

m:
	swift run todoAppNew migrate

clean:
	docker compose down -v --remove-orphans
	docker system prune -f

logs:
	docker compose logs -f todoAppNew

bash:
	docker compose exec todoAppNew bash
