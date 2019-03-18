package tradesvalidationservice;

import com.intuit.karate.junit5.Karate;

/**
 * Created by Lapbook on 15.03.2019.
 */
public class ValidationServicesTest {

    @Karate.Test
    Karate testValidationCommonValidations() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validate/commonValidations.feature");
    }

    @Karate.Test
    Karate testValidationSpotForward() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validate/spotForward.feature");
    }

    @Karate.Test
    Karate testValidationVanillaOption() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validate/vanillaOption.feature");
    }

    @Karate.Test
    Karate testValidationMultipleErrors() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validate/multipleerrors/multipleErrors.feature");
    }

    @Karate.Test
    Karate testValidatebatchMultipleErrors() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validatebatch/common/common.feature");
    }

    @Karate.Test
    Karate testValidatebatchOptions() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validatebatch/options/options.feature");
    }

    @Karate.Test
    Karate testValidatebatchSpotForward() {
        return new Karate()
                .feature("classpath:tradesvalidationservice/validatebatch/spotforward/spotForward.feature");
    }
}