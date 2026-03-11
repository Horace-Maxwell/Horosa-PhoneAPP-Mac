import { IconLogo } from "./icons"
import Sidebar from "./sidebar"
import UserNav from "./user-nav"

export default function Layout({ children }) {
  return (
    <main className="flex flex-col w-screen h-screen">
      <header className="flex-shrink-0 flex justify-between items-center px-3 py-2 h-16 border-b">
        <div className="flex items-center space-x-2">
          <IconLogo className="fill-foreground w-7 h-7" />
          <h1 className="text-lg font-bold">HOROSA</h1>
        </div>
        <UserNav />
      </header>
      <div className="flex flex-grow overflow-hidden">
        <div className="max-w-80 h-full border-r">
          <Sidebar />
        </div>
        <div className="flex-grow p-4 min-w-[1280px] overflow-auto">
          {children}
        </div>
      </div>
    </main>
  )
}
