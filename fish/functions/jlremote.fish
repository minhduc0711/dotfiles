function jlremote
    set port $argv[1]
    if test -z $port
        set port 8125
    end

    jupyter lab --no-browser --ip=0.0.0.0 --port=$port --allow-root
end
