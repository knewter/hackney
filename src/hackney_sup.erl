
-module(hackney_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    %% setup the default pool
    PoolOptions = [{name, hackney_pool}],
    DefaultPool = {hackney_pool,
                   {hackney_pool, start_link, [PoolOptions]},
                   permanent, 10000, worker, [hackney_pool]},
    %% start table to keep async streams ref
    ets:new(hackney_streams, [set, public, named_table]),
    {ok, { {one_for_one, 10, 1}, [DefaultPool]}}.

