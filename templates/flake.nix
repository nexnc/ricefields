{
  description = "Project templates";

  outputs = { self }: {
    templates = {
      # The default template (nix flake init -t univ)
      blank = { path = ./blank; description = "Minimal flake with direnv auto-loading"; };
      python = { path = ./python; description = "Python environment with uv and direnv"; };
      rust = { path = ./rust; description = "Rust development environment (Cargo/Analyzer)" ;};
      cpp = { path = ./cpp; description = "C++ Clang/CMake environment"; };
    };

    defaultTemplate = self.templates.blank;
  };
}
