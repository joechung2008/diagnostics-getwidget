# Build stage

# --- Build Stage ---
FROM debian:trixie-slim AS build

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
	curl git unzip xz-utils zip libglu1-mesa ca-certificates && \
	rm -rf /var/lib/apt/lists/*

# Install Flutter
ENV FLUTTER_VERSION=3.22.1
ENV FLUTTER_HOME=/opt/flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 $FLUTTER_HOME && \
	$FLUTTER_HOME/bin/flutter --version
ENV PATH="$FLUTTER_HOME/bin:$PATH"

WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# --- Serve Stage ---
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
