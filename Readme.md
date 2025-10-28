# Traefik Hub API Gateway

A complete Traefik Hub configuration with JWT authentication and WAF protection.

## Features

- 🔐 **JWT Authentication** with Keycloak integration
- 🛡️ **WAF Protection** with Coraza plugin ([Documentation](https://coraza.io/docs/tutorials/introduction/))
- 🌐 **HTTP Access** on port 80
- 📁 **File Provider** for dynamic configuration

## Dynamic Configuration

The `config/dynamic.yml` file contains:

- **Routes**: 
  - `httpbin` - Main service route with JWT auth and WAF protection
- **Middlewares**:
  - `jwt-auth` - JWT validation using Keycloak JWKS
  - `waf` - Web Application Firewall with OWASP Core Rule Set ([Coraza Documentation](https://coraza.io/docs/tutorials/introduction/))
- **Services**: Load balancer configuration for httpbin container

## Quick Start

1. **Setup Environment**
   ```bash
   # Copy and configure environment variables
   cp .env.example .env
   # Edit .env with your values
   ```

2. **Generate Dynamic Configuration**
   ```bash
   ./generate-config.sh
   ```

3. **Start Services**

   ```bash
   export TRAEFIK_HUB_TOKEN=<<add your token here>>
   docker-compose up -d
   ```

## API Routes

### Main Service Route
Access the httpbin service with JWT authentication:

```bash
# Make authenticated request to main service (replace YOUR_DOMAIN and JWT_TOKEN)
curl -H "Authorization: Bearer JWT_TOKEN" \
     http://YOUR_DOMAIN/get
```

### Without Authentication (will return 401)
```bash
# This will fail with 401 Unauthorized
curl http://YOUR_DOMAIN/get
```

### WAF Testing
```bash
# This will be blocked by WAF (403 Forbidden)
curl http://YOUR_DOMAIN/anything/admin

# Test other WAF rules
curl http://YOUR_DOMAIN/admin

# Normal request should work (but will return 401 due to JWT)
curl http://YOUR_DOMAIN/get
```

**Note**: All routes use HTTP via the `web` entrypoint (port 80).

## Monitoring

- **Dashboard**: http://localhost:8080
- **API**: http://localhost:8080/api
- **Logs**: `docker logs traefik-hub`

### Observability (Optional)

Observability exports (metrics, traces, logs) are available but commented out in `docker-compose.yml`. To enable:

1. Uncomment the observability configuration lines in the Traefik service
2. Set up your observability backend (OpenTelemetry Collector, Prometheus, Jaeger, etc.)
3. Configure endpoints in `.env` file:
   ```bash
   METRICS_ENDPOINT=http://your-collector:4318/v1/metrics
   TRACES_ENDPOINT=http://your-collector:4318/v1/traces
   LOGS_ENDPOINT=http://your-collector:4318/v1/logs
   ```
