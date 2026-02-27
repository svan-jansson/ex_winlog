ExUnit.start()

unless :os.type() == {:win32, :nt} do
  ExUnit.configure(exclude: [:windows])
end
