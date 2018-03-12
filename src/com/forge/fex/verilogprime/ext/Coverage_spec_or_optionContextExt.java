package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Coverage_spec_or_optionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Coverage_spec_or_optionContextExt extends AbstractBaseExt {

	public Coverage_spec_or_optionContextExt(Coverage_spec_or_optionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Coverage_spec_or_optionContext getContext() {
		return (Coverage_spec_or_optionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coverage_spec_or_option());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Coverage_spec_or_optionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Coverage_spec_or_optionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}