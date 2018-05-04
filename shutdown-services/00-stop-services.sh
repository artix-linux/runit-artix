stat_busy "Waiting for services to stop..."
    sv force-stop /run/runit/service/*
    sv exit /run/runit/service/*
stat_done
