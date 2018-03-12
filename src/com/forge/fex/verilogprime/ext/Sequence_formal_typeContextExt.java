package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequence_formal_typeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequence_formal_typeContextExt extends AbstractBaseExt {

	public Sequence_formal_typeContextExt(Sequence_formal_typeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequence_formal_typeContext getContext() {
		return (Sequence_formal_typeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequence_formal_type());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequence_formal_typeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequence_formal_typeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}