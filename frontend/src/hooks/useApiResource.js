import { useCallback, useEffect, useState } from 'react'

export function useApiResource(loader, initialValue = []) {
  const [data, setData] = useState(initialValue)
  const [status, setStatus] = useState('loading')
  const [error, setError] = useState(null)

  const reload = useCallback(async () => {
    setStatus('loading')
    setError(null)

    try {
      const result = await loader()
      setData(result)
      setStatus('success')
    } catch (requestError) {
      setError(requestError)
      setStatus('error')
    }
  }, [loader])

  useEffect(() => {
    let isCurrent = true

    loader()
      .then((result) => {
        if (!isCurrent) return
        setData(result)
        setStatus('success')
      })
      .catch((requestError) => {
        if (!isCurrent) return
        setError(requestError)
        setStatus('error')
      })

    return () => {
      isCurrent = false
    }
  }, [loader])

  return {
    data,
    error,
    isLoading: status === 'loading',
    isError: status === 'error',
    reload,
  }
}
