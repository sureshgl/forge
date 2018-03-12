package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Coverage_optionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Coverage_optionContextExt extends AbstractBaseExt {

	public Coverage_optionContextExt(Coverage_optionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Coverage_optionContext getContext() {
		return (Coverage_optionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).coverage_option());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Coverage_optionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Coverage_optionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}