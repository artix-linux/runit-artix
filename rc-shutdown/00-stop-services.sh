msg "Waiting for services to stop..."
sv force-stop /run/runit/service/*
sv exit /run/runit/service/*
