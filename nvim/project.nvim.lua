function setup()
    local ok, lspconfig = pcall(require, 'lspconfig')
    if not ok then
        return
    end

    local on_attach = assert(on_attach, "on_attach not defined")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem = {
        insertReplaceSupport = true,
        preselectSupport = true,
        snippetSupport = true
    }

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    python(lspconfig, opts)
end


function python(lspconfig, opts)
    local venv = 'venv/bin/python'

    opts["python"] = {
        pythonPath = venv,
    }
    lspconfig.pyright.setup(opts)

    local ok, dap_python = pcall(require, 'dap-python')
    if ok then
        dap_python.setup(venv)
    end
end


setup()
