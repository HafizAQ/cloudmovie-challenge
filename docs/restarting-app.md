# Restarting the Laptop

After restarting your laptop, the Docker container that was running your Flask app has most likely stopped. The image still exists, but the **container process is not running**, so `localhost:5000` will not respond.

Follow these checks.

### 1. Check running containers

```bash
docker ps
```

If nothing appears, check stopped containers:

```bash
docker ps -a
```

You should see something like:

```
cloudmovie-local   Exited
```

---

### 2. Restart the existing container

If the container exists:

```bash
docker start cloudmovie-local
```

Check logs:

```bash
docker logs --tail 50 cloudmovie-local
```

You should see:

```
Starting gunicorn
Listening at: http://0.0.0.0:5000
Booting worker
```

Now test:

```bash
curl http://localhost:5000/health
```

Expected:

```json
{"service":"cloudmovie-challenge","status":"healthy"}
```

Then open:

```
http://localhost:5000/
http://localhost:5000/game
http://localhost:5000/leaderboard
```

---

### 3. If container was removed

Run again:

```bash
docker images
```

You should see:

```
cloudmovie-local
```

Then recreate:

```bash
docker run -d \
--name cloudmovie-local \
-p 5000:5000 \
-e TMDB_SECRET_ID=$TMDB_SECRET_ID \
-e DYNAMODB_TABLE=$DYNAMODB_TABLE \
-e AWS_REGION=eu-central-1 \
-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
-e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
cloudmovie-local
```

Verify:

```bash
docker ps
```

---

### 4. If environment variables are lost after restart

Check:

```bash
docker inspect cloudmovie-local \
--format '{{range .Config.Env}}{{println .}}{{end}}' \
| grep -E 'TMDB|DYNAMODB|AWS'
```

You should see:

```
TMDB_SECRET_ID=arn:aws:secretsmanager...
DYNAMODB_TABLE=cloudmovie-challenge-dev-leaderboard
AWS_REGION=eu-central-1
```

If these are missing, recreate the container with the command above.

---

### 5. Confirm AWS credentials

Your laptop restart may also clear your shell environment.

Run:

```bash
aws sts get-caller-identity
```

Expected:

```json
{
    "Account": "203637464233",
    "Arn": "arn:aws:iam::203637464233:user/hquddus"
}
```

---

For your capstone workflow, after this we should **not rebuild everything**. We only need to bring the local demo environment back, then continue with:

1. Repository cleanup
2. README final architecture documentation
3. Screenshots:

   * AWS architecture
   * CloudWatch dashboard
   * Lambda
   * SNS alarm
   * Logs Insights query
   * Terraform
   * GitHub Actions
4. Demo script (10–12 min)
5. Presentation slides

First restore the container. Run:

```bash
docker ps -a
```

and share the output if it does not start.
