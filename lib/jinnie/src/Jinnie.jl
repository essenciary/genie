# include(abspath("lib/Mux/src/Mux.jl"))
# include(abspath("lib/Mustache/src/Mustache.jl"))

using Mux
using Mustache

renderer = Renderer() 

function include_controllers()
	include(abspath("lib/Jinnie/src/controller.jl"))
	for filename in readdir(abspath("app/controllers"))
		include(abspath(joinpath("app/controllers", filename)))
	end
end

function include_libs()
	include(abspath("lib/Jinnie/src/mux_extensions.jl"))
end

function app_setup()
	include_libs()
	include_controllers()

	@app app =
			(
				Mux.defaults,
				stack(Jinnie.req_logger),
				eval(routes)...,
				Mux.notfound()
			)
	
	return app
end

function start_server()
	@info "Starting server"
	s = @sync serve( app_setup() )
	# Base.throwto(s, InterruptException())
	# close(http.sock)
end