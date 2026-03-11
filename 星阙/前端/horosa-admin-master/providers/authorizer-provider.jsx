"use client";

import * as React from "react";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { StorageUtils } from "@/lib/storage"
import { KEYS } from "@/constant/keys";

const AuthorizerContext = React.createContext(null);

export const useAuthorizer = () => React.useContext(AuthorizerContext);

export default function AuthorizerProvider({ children }) {
  const [isLoggedIn, setIsLoggedIn] = React.useState(false)

  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  const handleSignInStatus = React.useCallback(() => {
    const token = StorageUtils.get(KEYS.ACCESS_TOKEN)
    if (token) {
      setIsLoggedIn(true)
      if (pathname === '/login') {
        const from = searchParams.get('from')
        router.replace(from || '/')
      }
    } else {
      setIsLoggedIn(false)
      if (pathname !== '/login') {
        router.replace('/login?from=' + pathname)
      }
    }
  }, [pathname, router, searchParams])

  const handleStorageChange = React.useCallback((event) => {
    if (event.key === KEYS.ACCESS_TOKEN) {
      handleSignInStatus();
    }
  }, [handleSignInStatus])

  React.useEffect(() => {
    handleSignInStatus();
    handleStorageChange({ key: KEYS.ACCESS_TOKEN })
    window.addEventListener("storage", handleStorageChange);

    return () => {
      window.removeEventListener("storage", handleStorageChange);
    }
  }, [handleSignInStatus, handleStorageChange])

  const value = React.useMemo(() => ({ isLoggedIn, setIsLoggedIn }), [isLoggedIn])

  return (
    <AuthorizerContext.Provider value={value}>
      {children}
    </AuthorizerContext.Provider>
  )
}
