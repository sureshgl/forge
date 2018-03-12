package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Seq_input_listContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Seq_input_listContextExt extends AbstractBaseExt {

	public Seq_input_listContextExt(Seq_input_listContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Seq_input_listContext getContext() {
		return (Seq_input_listContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).seq_input_list());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Seq_input_listContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Seq_input_listContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}