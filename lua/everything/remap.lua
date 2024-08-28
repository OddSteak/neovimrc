vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", function()
    require("oil").open()
end)

vim.keymap.set("n", "<leader>v", function()
    require("oil").toggle_float()
end)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z") -- preserve cursor pos when joining lines
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- replace the selection with register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- leader y and motion cmd copy to clipboard in normal mode
-- leader y copies to clipboard in visual mode
-- leader Y copy the line
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete to the void
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz")
-- cycle location list
-- the list is populated like :lgrep pattern *.txt
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace word in the whole file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
    "n",
    "<leader>jm",
    "opublic static void main(String[] args) {<CR>}<Esc>OSystem.out.println();<Esc>hi"
)

vim.keymap.set(
    "n",
    "<leader>tt",
    "o\\begin{displaymath}<CR>\\begin{array}{|c c| c |}<CR>\\hline<CR>P & Q & \\\\<CR>\\hline<CR>\\hline<CR>\\end{array}<CR>\\end{displaymath}<Esc>6kf};i"
)

vim.keymap.set(
    "n",
    "<leader>jp",
    "oSystem.out.println();<Esc>hi"
)

vim.keymap.set("n", "<leader>o", "o<Esc>k")
vim.keymap.set("n", "<leader>O", "O<Esc>j")

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

local copilot_on = true
vim.api.nvim_create_user_command("CopilotToggle", function()
	if copilot_on then
		vim.cmd("Copilot disable")
		print("Copilot OFF")
	else
		vim.cmd("Copilot enable")
		print("Copilot ON")
	end
	copilot_on = not copilot_on
end, { nargs = 0 })

vim.keymap.set({"n", "i"}, "<M-\\>", "<cmd>CopilotToggle<CR>", { noremap = true, silent = true })
