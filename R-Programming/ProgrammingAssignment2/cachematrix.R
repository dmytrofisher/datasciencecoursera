## A pair of functions that cache the inverse of a matrix.

## Creates a special matrix object that can cache its iverse.
makeCacheMatrix <- function(x = matrix()) {

	## cached inverse matrix
	i <- NULL
	
	## function for set the value of matrix
	set <- function(y){
		x <<- y
		i <<- NULL
	}
	
	## function for get the value of matrix
	get <- function() x
	
	## function to set the value of cached inverse matrix
	setInverse <- function(inverse) i <<- inverse
	
	## function to get the value of cached inverse matrix
	getInverse <- function() i
	
	list( set = set
		, get = get
		, setInverse = setInverse
		, getInverse = getInverse)
}


## Computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
## If the inverse has already been calculated (and the matrix has not changed), 
## then the cachesolve should retrieve the inverse from the cache.
cacheSolve <- function(x, ...) {

	## try to get cached values
	inv <- x $ getInverse()
	
	## if the cahed value obtained - return it
	if (!is.null(inv)){
		message("Getting cached data")
		return(inv)
	}
	
	## otherwise get value of matrix
	data <- x $ get()
	
	## caluclate inverse matrix	...
	inv <- solve(data, ...)
	
	## ... and store it in cache
	x $ setInverse(inv)
	
	## return inverse matrix
	inv
}
