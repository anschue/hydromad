\name{armax.inverse.sim}
\alias{armax.inverse.sim}
\alias{expuh.inverse.sim}
\title{ Invert transfer function models to estimate input series. }
\description{
  Invert transfer function models to estimate input series.
}
\usage{
armax.inverse.sim(DATA,
             a_1 = 0, a_2 = 0, a_3 = 0, 
             b_0 = 1, b_1 = 0, b_2 = 0, b_3 = 0,
             pars = NULL,
             delay = 0, init = 0,
             rain.factor = 1.1,
             rises.only = FALSE,
             use.Qm = TRUE,
             use.fft.method = FALSE,
             constrain.fft = TRUE,
             mass.balance = use.fft.method,
             scale.window = NA)

expuh.inverse.sim(DATA, delay = 0,
             tau_s = 0, tau_q = 0, tau_3 = 0,
             v_s = 1, v_q = NA, v_3 = 0,
             series = 0, 
             Xs_0 = 0, Xq_0 = 0, X3_0 = 0,
             pars = NULL,
             ...)
}
\arguments{
  \item{DATA}{
    time-series-like object with columns \code{Q} (streamflow) and
    optionally \code{P} (precipitation).
  }
  \item{delay}{
    delay (lag time / dead time) in number of time steps.
  }

  
}
\details{

}
\value{

}
\references{
...
}
\author{ Felix Andrews \email{felix@nfrac.org} }
\seealso{
  \code{\link{armax.inverse.fit}},
  \code{\link{armax}},
  \code{\link{expuh}}
}
\examples{
## baseflow filtering using two-store unit hydrograph
data(Murrindindi)
x <- Murrindindi[1:1000,]

## case 1 (preferred): streamflow + rainfall data constrained
## such that effective rainfall is less than observed rainfall
foo <- hydromad(x, sma = "armax.inverse", routing = "armax",
                rfit = list("inverse", order = c(2,1)))
foo
xsq <- predict(foo, return_components = TRUE)
xyplot(cbind(observed = x$Q, slow_component = xsq$Xs), superpose = TRUE)

## case 2: using streamflow data only, constrained
## to have effective rainfall only when flow is rising
foo <- hydromad(x$Q, sma = "armax.inverse", routing = "armax",
                rfit = list("inverse", order = c(2,1), rises.only = TRUE))
xsq <- predict(foo, return_components = TRUE)
xyplot(cbind(observed = x$Q, slow_component = xsq$Xs), superpose = TRUE)

## case 3: using streamflow data only, unconstrained
foo <- hydromad(x$Q, sma = "armax.inverse", routing = "armax",
                rfit = list("inverse", order = c(2,1)))
xsq <- predict(foo, return_components = TRUE)
xyplot(cbind(observed = x$Q, slow_component = xsq$Xs), superpose = TRUE)

}
\keyword{ ts }

