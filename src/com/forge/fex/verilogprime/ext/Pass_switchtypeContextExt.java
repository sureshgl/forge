package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pass_switchtypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pass_switchtypeContextExt extends AbstractBaseExt {

	public Pass_switchtypeContextExt(Pass_switchtypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pass_switchtypeContext getContext() {
		return (Pass_switchtypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pass_switchtype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pass_switchtypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pass_switchtypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}