package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NandContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NandContextExt extends AbstractBaseExt {

	public NandContextExt(NandContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NandContext getContext() {
		return (NandContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).nand());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NandContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NandContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}