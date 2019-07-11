-module(rabbitmq_prelaunch_feature_flags).

-export([setup/1]).

setup(#{feature_flags_file := FFFile}) ->
    rabbit_log_prelaunch:debug(""),
    rabbit_log_prelaunch:debug("== Feature flags =="),
    Parent = filename:dirname(FFFile),
    case rabbitmq_prelaunch_helpers:mkdir_p(Parent) of
        ok ->
            rabbit_log_prelaunch:debug("Initializing feature flags registry"),
            case rabbit_feature_flags:initialize_registry() of
                ok ->
                    ok;
                {error, Reason} ->
                    rabbit_log_prelaunch:error(
                      "Failed to initialize feature flags registry: ~p",
                      [Reason]),
                    rabbitmq_prelaunch_helpers:exit(ex_software)
            end;
        {error, Reason} ->
            rabbit_log_prelaunch:error(
              "Failed to create feature flags file \"~s\" directory: ~s",
              [FFFile, file:format_error(Reason)]),
            rabbitmq_prelaunch_helpers:exit(ex_cantcreat)
    end.